using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Pirate : BaseFighter
    {
        public Pirate(int level = 4)
        {
            Level = level;
            Health = Stat(79, 111, 5, 10, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(16, 25, 2, 5, 4);
            PhysicalDefense = Stat(16, 25, 2, 5, 4);
            MagicAttack = Stat(8, 16, 1, 3, 4);
            MagicDefense = Stat(8, 16, 1, 3, 4);
            Speed = Stat(11, 22, 2, 5, 4);
            Abilities = new List<Ability>() { new Flintlock(), new DirtyTrick() };
            CharacterType = "Pirate";
            Mana = Stat(16, 38, 2, 7, 4);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 4;
            DodgeChance = 2;
        }

        public Pirate(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Pirate(this);
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
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
