using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Lava : Ability
    {
        public Lava()
        {
            Name = "Lava";
            FlavorText = "It runs, it flows, and it burns in its wake.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 8;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 6;
        }
    }
}
