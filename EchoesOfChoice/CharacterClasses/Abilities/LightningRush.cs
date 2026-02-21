using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class LightningRush : Ability
    {
        public LightningRush()
        {
            Name = "Lightning Rush";
            FlavorText = "Surge electrical energy through an ally, supercharging their reflexes. Increases speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 2;
        }
    }
}
