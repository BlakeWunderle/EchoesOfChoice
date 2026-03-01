using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Shade : BaseFighter
    {
        public Shade(int level = 7)
        {
            Level = level;
            Health = Stat(108, 128, 5, 9, 7);
            MaxHealth = Health;
            PhysicalAttack = Stat(16, 22, 1, 3, 7);
            PhysicalDefense = Stat(15, 20, 1, 3, 7);
            MagicAttack = Stat(35, 43, 3, 5, 7);
            MagicDefense = Stat(18, 24, 2, 4, 7);
            Speed = Stat(33, 39, 2, 4, 7);
            Abilities = new List<Ability>() { new ShadowAttack(), new Abilities.Enemy.Blight(), new Frustrate() };
            CharacterType = "Shade";
            Mana = Stat(24, 34, 2, 5, 7);
            MaxMana = Mana;
            CritChance = 23;
            CritDamage = 2;
            DodgeChance = 31;
        }

        public Shade(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Shade(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 5);
            PhysicalDefense += random.Next(1, 4);
            MagicAttack += random.Next(2, 6);
            MagicDefense += random.Next(2, 5);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
