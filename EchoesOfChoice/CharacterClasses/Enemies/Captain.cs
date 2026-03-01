using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Captain : BaseFighter
    {
        public Captain(int level = 5)
        {
            Level = level;
            Health = Stat(102, 140, 5, 11, 5);
            MaxHealth = Health;
            PhysicalAttack = Stat(25, 36, 2, 5, 5);
            PhysicalDefense = Stat(21, 32, 2, 5, 5);
            MagicAttack = Stat(8, 16, 1, 3, 5);
            MagicDefense = Stat(8, 16, 1, 3, 5);
            Speed = Stat(18, 26, 1, 2, 5);
            Abilities = new List<Ability>() { new Flintlock(), new CannonBarrage(), new Bravado() };
            CharacterType = "Captain";
            Mana = Stat(23, 49, 2, 7, 5);
            MaxMana = Mana;
            CritChance = 30;
            CritDamage = 3;
            DodgeChance = 10;
        }

        public Captain(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Captain(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 5);
            PhysicalDefense += random.Next(2, 5);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
