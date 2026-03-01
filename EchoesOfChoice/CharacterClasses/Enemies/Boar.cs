using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Boar : BaseFighter
    {
        public Boar(int level = 2)
        {
            Level = level;
            Health = Stat(64, 74, 5, 8, 2);
            MaxHealth = Health;
            PhysicalAttack = Stat(20, 24, 2, 4, 2);
            PhysicalDefense = Stat(12, 16, 1, 3, 2);
            MagicAttack = Stat(2, 4, 0, 1, 2);
            MagicDefense = Stat(8, 12, 1, 2, 2);
            Speed = Stat(18, 24, 1, 2, 2);
            Abilities = new List<Ability>() { new Gore(), new Charge() };
            CharacterType = "Boar";
            Mana = Stat(6, 10, 1, 3, 2);
            MaxMana = Mana;
            CritChance = 10;
            CritDamage = 2;
            DodgeChance = 5;
        }

        public Boar(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Boar(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(4, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
